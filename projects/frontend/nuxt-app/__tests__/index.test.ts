import { mount } from '@vue/test-utils'
import Page from '../pages/index.vue'

test('renders nuxt welcome', () => {
  const wrapper = mount(Page)
  expect(wrapper.text()).toContain('Nuxt App - DevSecOps Portfolio')
})
