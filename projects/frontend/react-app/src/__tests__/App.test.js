import { render, screen, fireEvent } from '@testing-library/react';
import App from '../App';

// Mock web-vitals
jest.mock('web-vitals', () => ({
  getCLS: jest.fn(),
  getFID: jest.fn(),
  getFCP: jest.fn(),
  getLCP: jest.fn(),
  getTTFB: jest.fn(),
}));

describe('DevSecOps React App', () => {
  test('renders main title', () => {
    render(<App />);
    const titleElement = screen.getByText(/DevSecOps Portfolio Demo/i);
    expect(titleElement).toBeInTheDocument();
  });

  test('displays security features', () => {
    render(<App />);
    const cspFeature = screen.getByText(/Content Security Policy/i);
    expect(cspFeature).toBeInTheDocument();
  });

  test('shows environment status', () => {
    render(<App />);
    const envStatus = screen.getByText(/Environment:/i);
    expect(envStatus).toBeInTheDocument();
  });

  test('handles API test button click', () => {
    // Mock alert
    window.alert = jest.fn();
    
    render(<App />);
    const apiButton = screen.getByText(/Test API Connection/i);
    fireEvent.click(apiButton);
    
    expect(window.alert).toHaveBeenCalledWith(
      expect.stringContaining('API test triggered')
    );
  });

  test('handles security test button click', () => {
    // Mock alert
    window.alert = jest.fn();
    
    render(<App />);
    const securityButton = screen.getByText(/Run Security Check/i);
    fireEvent.click(securityButton);
    
    expect(window.alert).toHaveBeenCalledWith(
      expect.stringContaining('Security scan initiated')
    );
  });

  test('displays metrics correctly', () => {
    render(<App />);
    const securityScore = screen.getByText('100%');
    const testCoverage = screen.getByText('95%');
    expect(securityScore).toBeInTheDocument();
    expect(testCoverage).toBeInTheDocument();
  });

  test('shows contact information', () => {
    render(<App />);
    const contactEmail = screen.getByText(/msrj.xyz@gmail.com/i);
    const githubHandle = screen.getByText(/@msrj-xyz/i);
    expect(contactEmail).toBeInTheDocument();
    expect(githubHandle).toBeInTheDocument();
  });

  test('displays deployment strategy', () => {
    render(<App />);
    const developmentDeploy = screen.getByText(/Development → Auto Deploy/i);
    const productionDeploy = screen.getByText(/Production → Blue-Green/i);
    expect(developmentDeploy).toBeInTheDocument();
    expect(productionDeploy).toBeInTheDocument();
  });
});