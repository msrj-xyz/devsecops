import { render, screen } from '@testing-library/react'
import Home from '../pages/index'

test('renders welcome text', () => {
  render(<Home />)
  expect(screen.getByText(/Next.js App - DevSecOps Portfolio/)).toBeInTheDocument()
})
