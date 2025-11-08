import { bulkStudentSchema, createStudentSchema, updateStudentSchema } from '../dtos/student.dto.js';
import HttpError from '../errors/http-error.js';
import StudentRepository from '../repositories/student.repository.js';

export default class StudentService {
  constructor(repository = new StudentRepository()) {
    this.repository = repository;
  }

  async list(filters = {}) {
    return this.repository.findAll(filters);
  }

  async getById(id) {
    const student = await this.repository.findById(id);
    if (!student) {
      throw new HttpError(404, 'Aluno não encontrado');
    }
    return student;
  }

  async create(payload) {
    const parsed = createStudentSchema.parse(payload);
    return this.repository.create(parsed);
  }

  async update(id, payload) {
    const parsed = updateStudentSchema.parse(payload);
    const updated = await this.repository.update(id, parsed);
    if (!updated) {
      throw new HttpError(404, 'Aluno não encontrado');
    }
    return updated;
  }

  async remove(id) {
    const deleted = await this.repository.delete(id);
    if (!deleted) {
      throw new HttpError(404, 'Aluno não encontrado');
    }
  }

  async removeAll() {
    await this.repository.deleteAll();
  }

  async importMany(payload) {
    const parsed = bulkStudentSchema.parse(payload);
    return this.repository.bulkCreate(parsed);
  }
}

