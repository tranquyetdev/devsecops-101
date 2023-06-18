import * as core from '@actions/core';
import isCI from 'is-ci';
import { getAffectedProjects } from './nx';
import { IDeployMatrix, getDeployConfig } from './deploy';

export const setOutput = (name: string, value: any) => {
  const output = JSON.stringify(value || { run: false, name: 'SKIP' })
  if (isCI) {
    core.setOutput(`${name}`, `${output}`);
  } else {
    console.log(`${name}=${output}`);
  }
};

(function setMatrix() {
  console.log('setMatrix...');

  const affectedProjects = getAffectedProjects();
  console.log(`affectedProjects`, affectedProjects);

  const allMatrix: IDeployMatrix = {
    ecsMatrix: {
      include: [],
    },
    cloudfrontMatrix: {
      include: [],
    },
  };

  affectedProjects.forEach((project) => {
    const { matrix, projectId } = getDeployConfig(project);

    if (matrix.ecsMatrix) {
      allMatrix.ecsMatrix.include.push({
        run: true,
        name: projectId,
      });
    }

    if (matrix.cloudfrontMatrix) {
      allMatrix.cloudfrontMatrix.include.push({
        run: true,
        name: projectId,
      });
    }
  });

  const skipped = { run: false, name: 'SKIP' };
  if (allMatrix.ecsMatrix.include.length === 0) {
    allMatrix.ecsMatrix.include.push(skipped);
  }

  if (allMatrix.cloudfrontMatrix.include.length === 0) {
    allMatrix.cloudfrontMatrix.include.push(skipped);
  }

  console.log(`ecsMatrix`, allMatrix.ecsMatrix);
  console.log(`cloudfrontMatrix`, allMatrix.cloudfrontMatrix);

  setOutput('affectedProjects', affectedProjects);
  setOutput('ecsMatrix', allMatrix.ecsMatrix);
  setOutput('cloudfrontMatrix', allMatrix.cloudfrontMatrix);
})();
