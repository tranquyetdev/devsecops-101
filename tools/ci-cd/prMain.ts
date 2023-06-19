import { getAffectedProjects, getEnvironment, setOutput } from './utils';
import { getCloudFrontMatrix, getECSMatrix } from './matrix';

(function setMatrix() {
  const affectedProjects = getAffectedProjects();
  const environment = getEnvironment(process.env.CURRENT_BRANCH || '');

  if (!environment) {
    throw new Error(
      `Environment is not defined for branch ${process.env.CURRENT_BRANCH}`
    );
  }

  console.log(`affectedProjects`, affectedProjects);
  console.log(`environment`, environment);

  setOutput('affectedProjects', affectedProjects);
  setOutput('ecsMatrix', getECSMatrix(environment, affectedProjects));
  setOutput(
    'cloudfrontMatrix',
    getCloudFrontMatrix(environment, affectedProjects)
  );
})();
