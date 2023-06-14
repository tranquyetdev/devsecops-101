import * as core from '@actions/core';
import isCI from 'is-ci';
import { getAffectedBuild, getAffectedTest } from './nx';

export const setOutput = (name: string, value: any) => {
  const skip = [
    {
      name: 'SKIP',
      shortName: 'SKIP',
      run: false,
    },
  ];

  const matrix =
    (Array.isArray(value) || typeof value === 'string') && value.length === 0
      ? skip
      : value;

  const output = Array.isArray(value)
    ? isCI
      ? JSON.stringify({ include: matrix })
      : JSON.stringify({ include: matrix }, null, 2)
    : value;

  // eslint-disable-next-line
  console.log(`matrix ${name} = ${output}`);

  if (isCI) {
    core.setOutput(`${name}`, `${output}`);
  } else {
    // eslint-disable-next-line
    console.log(`${name}=${output}`);
  }
};

(function setMatrix() {
  console.log('setMatrix...');

  const affectedTestPackages = getAffectedTest();
  const affectedBuildPackages = getAffectedBuild();

  console.log(`affectedTestPackages`, affectedTestPackages);
  console.log(`affectedBuildPackages`, affectedBuildPackages);

  // setOutput('all_matrix', allPackagesMatrix)
  // setOutput('web_matrix', webMatrix)
})();
