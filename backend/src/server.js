import app from './app.js';
import env from './config/env.js';
import StudentRepository from './repositories/student.repository.js';

const start = async () => {
  const repository = new StudentRepository();
  await repository.initialize();

  app.listen(env.port, () => {
    console.info(`🚀 Server listening on http://localhost:${env.port}`);
  });
};

start().catch((error) => {
  console.error('Failed to start server', error);
  process.exit(1);
});

