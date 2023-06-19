import {
  IDeployMatrix,
  IDeployMatrixActionConfig,
  getDeployConfig,
} from './deploy';

/**
 * Get CloudFront deployment matrix
 *
 * @param environment environment name
 * @param affectedProjects affected projects
 * @returns deployment matrix
 */
export const getCloudFrontMatrix = (
  environment: string,
  affectedProjects: string[] = []
) => {
  const deployMatrix: IDeployMatrix = {
    include: [],
  };

  affectedProjects.forEach((project) => {
    const { matrix, projectId } = getDeployConfig(project);
    if (matrix.cloudfrontMatrix) {
      const environmentConfig =
        matrix.cloudfrontMatrix.environments[environment];

      deployMatrix.include.push({
        run: true,
        name: projectId,
        awsRegion: matrix.cloudfrontMatrix.awsRegion,
        environment,
        ...environmentConfig,
      });
    }
  });

  if (
    !affectedProjects ||
    affectedProjects.length === 0 ||
    deployMatrix.include.length === 0
  ) {
    deployMatrix.include.push({
      run: false,
      name: 'SKIP',
    });
  }

  console.log('getCloudFrontMatrix:', deployMatrix);

  return deployMatrix;
};

/**
 * Get ECS deployment matrix
 *
 * @param environment environment name
 * @param affectedProjects affected projects
 * @returns deployment matrix
 */
export const getECSMatrix = (
  environment: string,
  affectedProjects: string[] = []
) => {
  const deployMatrix: IDeployMatrix = {
    include: [],
  };

  affectedProjects.forEach((project) => {
    const { matrix, projectId } = getDeployConfig(project);
    if (matrix.ecsMatrix) {
      const environmentConfig = matrix.ecsMatrix.environments[environment];

      deployMatrix.include.push({
        run: true,
        name: projectId,
        awsRegion: matrix.ecsMatrix.awsRegion,
        environment,
        ...environmentConfig,
      });
    }
  });

  if (
    !affectedProjects ||
    affectedProjects.length === 0 ||
    deployMatrix.include.length === 0
  ) {
    deployMatrix.include.push({
      run: false,
      name: 'SKIP',
    });
  }

  console.log('getECSMatrix:', deployMatrix);

  return deployMatrix;
};
