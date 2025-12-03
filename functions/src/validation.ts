import { z } from 'zod';

export const ContactSettingsSchema = z.object({
  phone: z.string().min(3),
  email: z.string().email(),
  address: z.string().optional(),
  hours: z.string().optional(),
});

export type ContactSettings = z.infer<typeof ContactSettingsSchema>;
