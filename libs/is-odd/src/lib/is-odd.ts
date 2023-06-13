import { isEven } from '@aws-cloud-pratice/is-even';

export function isOdd(n: number): boolean {
  return !isEven(n);
}
