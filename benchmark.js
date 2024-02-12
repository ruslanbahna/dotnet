const Benchmark = require('benchmark');

const suite = new Benchmark.Suite();

function fibonacci(n) {
  if (n <= 1) {
    return n;
  }
  return fibonacci(n - 1) + fibonacci(n - 2);
}

function factorial(n) {
  let result = 1;
  for (let i = 1; i <= n; i++) {
    result *= i;
  }
  return result;
}

suite
  .add('Test Case 1', () => {
    const result = fibonacci(20); // Calculate Fibonacci number at index 20
  })
  .add('Test Case 2', () => {
    const result = factorial(10); // Calculate factorial of 10
  })
  .on('cycle', (event) => {
    console.log(String(event.target));
  })
  .on('complete', () => {
    console.log('Benchmark completed.');
  })
  .run({ async: true });