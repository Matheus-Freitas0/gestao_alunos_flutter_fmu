import { getDatabasePool } from '../config/database.js';
import { studentStatuses } from '../models/student.model.js';

const TABLE_NAME = 'alunos';

const mapRowToStudent = (row) => ({
  id: Number(row.id),
  nome: row.nome,
  idade: Number(row.idade),
  curso: row.curso,
  email: row.email,
  telefone: row.telefone,
  dataCadastro: new Date(row.data_cadastro),
  status: row.status,
});

export default class StudentRepository {
  constructor(pool = getDatabasePool()) {
    this.pool = pool;
  }

  async initialize() {
    await this.pool.execute(`
      CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(120) NOT NULL,
        idade INT NOT NULL,
        curso VARCHAR(120) NOT NULL,
        email VARCHAR(120) NOT NULL,
        telefone VARCHAR(20) NOT NULL,
        data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        status ENUM('ativo', 'inativo', 'trancado') NOT NULL DEFAULT 'ativo',
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY unique_email (email)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
  }

  async findAll(filters = {}) {
    const conditions = [];
    const params = [];

    if (filters.status && studentStatuses.includes(filters.status)) {
      conditions.push('status = ?');
      params.push(filters.status);
    }

    if (filters.search) {
      conditions.push('(nome LIKE ? OR curso LIKE ? OR email LIKE ?)');
      const pattern = `%${filters.search}%`;
      params.push(pattern, pattern, pattern);
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    const [rows] = await this.pool.query(
      `SELECT * FROM ${TABLE_NAME} ${whereClause} ORDER BY nome ASC`,
      params,
    );
    return rows.map(mapRowToStudent);
  }

  async findById(id) {
    const [rows] = await this.pool.query(
      `SELECT * FROM ${TABLE_NAME} WHERE id = ? LIMIT 1`,
      [id],
    );
    if (rows.length === 0) {
      return null;
    }
    return mapRowToStudent(rows[0]);
  }

  async create(payload) {
    const now = new Date();
    const dataCadastro = payload.dataCadastro ? new Date(payload.dataCadastro) : now;
    const status = payload.status ?? 'ativo';

    const [result] = await this.pool.execute(
      `
        INSERT INTO ${TABLE_NAME}
          (nome, idade, curso, email, telefone, data_cadastro, status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        payload.nome,
        payload.idade,
        payload.curso,
        payload.email,
        payload.telefone,
        dataCadastro,
        status,
      ],
    );

    const createdStudent = await this.findById(result.insertId);
    if (!createdStudent) {
      throw new Error('Falha ao criar aluno');
    }
    return createdStudent;
  }

  async update(id, payload) {
    if (!payload || Object.keys(payload).length === 0) {
      return this.findById(id);
    }

    const fields = [];
    const values = [];

    if (payload.nome !== undefined) {
      fields.push('nome = ?');
      values.push(payload.nome);
    }
    if (payload.idade !== undefined) {
      fields.push('idade = ?');
      values.push(payload.idade);
    }
    if (payload.curso !== undefined) {
      fields.push('curso = ?');
      values.push(payload.curso);
    }
    if (payload.email !== undefined) {
      fields.push('email = ?');
      values.push(payload.email);
    }
    if (payload.telefone !== undefined) {
      fields.push('telefone = ?');
      values.push(payload.telefone);
    }
    if (payload.dataCadastro !== undefined) {
      fields.push('data_cadastro = ?');
      values.push(new Date(payload.dataCadastro));
    }
    if (payload.status !== undefined) {
      fields.push('status = ?');
      values.push(payload.status);
    }

    if (fields.length === 0) {
      return this.findById(id);
    }

    values.push(id);

    const [result] = await this.pool.execute(
      `UPDATE ${TABLE_NAME} SET ${fields.join(', ')} WHERE id = ?`,
      values,
    );

    if (result.affectedRows === 0) {
      return null;
    }

    return this.findById(id);
  }

  async delete(id) {
    const [result] = await this.pool.execute(
      `DELETE FROM ${TABLE_NAME} WHERE id = ?`,
      [id],
    );
    return result.affectedRows > 0;
  }

  async deleteAll() {
    await this.pool.execute(`DELETE FROM ${TABLE_NAME}`);
    await this.pool.execute(`ALTER TABLE ${TABLE_NAME} AUTO_INCREMENT = 1`);
  }

  async bulkCreate(payloads = []) {
    if (payloads.length === 0) {
      return 0;
    }

    const connection = await this.pool.getConnection();
    try {
      await connection.beginTransaction();
      for (const payload of payloads) {
        const dataCadastro = payload.dataCadastro ? new Date(payload.dataCadastro) : new Date();
        const status = payload.status ?? 'ativo';

        await connection.execute(
          `
            INSERT INTO ${TABLE_NAME}
              (nome, idade, curso, email, telefone, data_cadastro, status)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
              nome = VALUES(nome),
              idade = VALUES(idade),
              curso = VALUES(curso),
              telefone = VALUES(telefone),
              data_cadastro = VALUES(data_cadastro),
              status = VALUES(status)
          `,
          [
            payload.nome,
            payload.idade,
            payload.curso,
            payload.email,
            payload.telefone,
            dataCadastro,
            status,
          ],
        );
      }

      await connection.commit();
      return payloads.length;
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }
}

