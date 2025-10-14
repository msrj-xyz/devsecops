import { defineNuxtConfig } from 'nuxt'

export default defineNuxtConfig({
  typescript: {
    shim: false
  },
  ssr: true,
  app: {
    head: {
      title: 'Nuxt App - DevSecOps'
    }
  }
})
