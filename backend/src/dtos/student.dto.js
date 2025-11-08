import { z } from 'zod';

const statusEnum = z.enum(['ativo', 'inativo', 'trancado']);

export const createStudentSchema = z
  .object({
    nome: z.string().min(2, 'Nome é obrigatório'),
    idade: z.number().int().min(16).max(100),
    curso: z.string().min(2, 'Curso é obrigatório'),
    email: z.string().email('E-mail inválido'),
    telefone: z.string().min(10, 'Telefone inválido'),
    dataCadastro: z
      .string()
      .refine(
        (value) => !value || !Number.isNaN(new Date(value).getTime()),
        'Data de cadastro inválida',
      )
      .optional(),
    status: statusEnum.optional(),
  })
  .strict();

export const updateStudentSchema = createStudentSchema.partial();
export const bulkStudentSchema = z.array(createStudentSchema);
