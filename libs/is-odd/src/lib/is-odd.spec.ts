import { isOdd } from './is-odd';

describe('isOdd', () => {
  it('should work', () => {
    expect(isOdd(1)).toEqual(true);
  });

  it('should work', () => {
    expect(isOdd(2)).toEqual(false);
  });
});
