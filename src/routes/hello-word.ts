import { FastifyInstance } from 'fastify'
import { ZodTypeProvider } from 'fastify-type-provider-zod'
import z from 'zod'

export async function helloWorld(app: FastifyInstance) {
  app.withTypeProvider<ZodTypeProvider>().get(
    '/',
    {
      schema: {
        tags: ['Default'],
        summary: 'Hello World!',
        response: {
          200: z.object({
            success: z.boolean(),
            teste: z.boolean(),
            newRoute: z.boolean(),
          }),
        },
      },
    },
    async (_, reply) => {
      reply.status(200).send({
        success: true,
        teste: true,
        newRoute: true,
      })
    },
  )
}
