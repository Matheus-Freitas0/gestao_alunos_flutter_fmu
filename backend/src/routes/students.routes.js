import { Router } from 'express';

import StudentController from '../controllers/student.controller.js';

const router = Router();
const controller = new StudentController();

router.get('/', controller.list);
router.post('/', controller.create);
router.post('/import', controller.importMany);
router.delete('/', controller.removeAll);
router.get('/:id', controller.getById);
router.put('/:id', controller.update);
router.delete('/:id', controller.remove);

export default router;

