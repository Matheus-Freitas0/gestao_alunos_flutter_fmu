import StudentService from '../services/student.service.js';

export default class StudentController {
  constructor(service = new StudentService()) {
    this.service = service;
  }

  list = async (req, res) => {
    const students = await this.service.list({
      status: typeof req.query.status === 'string' ? req.query.status : undefined,
      search: typeof req.query.search === 'string' ? req.query.search : undefined,
    });
    res.json(students);
  };

  getById = async (req, res) => {
    const id = Number.parseInt(req.params.id, 10);
    const student = await this.service.getById(id);
    res.json(student);
  };

  create = async (req, res) => {
    const student = await this.service.create(req.body);
    res.status(201).json(student);
  };

  update = async (req, res) => {
    const id = Number.parseInt(req.params.id, 10);
    const student = await this.service.update(id, req.body);
    res.json(student);
  };

  remove = async (req, res) => {
    const id = Number.parseInt(req.params.id, 10);
    await this.service.remove(id);
    res.status(204).send();
  };

  removeAll = async (_req, res) => {
    await this.service.removeAll();
    res.status(204).send();
  };

  importMany = async (req, res) => {
    const payload = Array.isArray(req.body) ? req.body : [];
    const imported = await this.service.importMany(payload);
    res.status(201).json({ imported });
  };
}

