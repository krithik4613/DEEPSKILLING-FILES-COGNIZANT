import { Component } from 'react';

// Task 3: global error handler (React version).
// Angular equivalent: a custom ErrorHandler service (see ngrx-concept.md).
// Vue equivalent: app.config.errorHandler (see handson_08/src/main.js).
export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    console.error('Caught by ErrorBoundary:', error, info);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="fallback-ui">
          <h2>Something went wrong.</h2>
          <p>Please refresh the page or try again later.</p>
        </div>
      );
    }
    return this.props.children;
  }
}
