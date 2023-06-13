import { isEven } from './is-even';

describe('isEven', () => {
  it('should work', () => {
    expect(isEven(1)).toEqual(false);
  });
  it('should work', () => {
    expect(isEven(2)).toEqual(true);
  });
});
