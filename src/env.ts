import z from 'zod'

const envSchema = z.object({
  SERVER_PORT: z.number().optional().default(8080),
})

const _env = envSchema.safeParse(process.env)

if (_env.success === false) {
  console.log('Invalid environment variables', _env.error.format())

  throw new Error('Invalid environment variables')
}

export const env = _env.data
