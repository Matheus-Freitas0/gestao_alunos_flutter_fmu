import 'dotenv/config';

const env = {
  port: Number.parseInt(process.env.PORT ?? '3000', 10),
  mysql: {
    host: process.env.MYSQL_HOST ?? '127.0.0.1',
    port: Number.parseInt(process.env.MYSQL_PORT ?? '3306', 10),
    user: process.env.MYSQL_USER ?? 'root',
    password: process.env.MYSQL_PASSWORD ?? 'root',
    database: process.env.MYSQL_DATABASE ?? 'gestao_alunos',
    connectionLimit: Number.parseInt(process.env.MYSQL_CONNECTION_LIMIT ?? '10', 10),
  },
};

export default env;
