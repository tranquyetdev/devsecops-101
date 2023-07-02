import { IDeployMatrix, getDeployConfig } from './deploy';

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
    const deployConfig = getDeployConfig(project);

    if (deployConfig) {
      const { matrix, appName, appId, namespace } = deployConfig;
      if (matrix.cloudfrontMatrix) {
        const environmentConfig =
          matrix.cloudfrontMatrix.environments[environment];

        deployMatrix.include.push({
          run: true,
          appName,
          appId,
          namespace,
          awsRegion: matrix.cloudfrontMatrix.awsRegion,
          environment,
          ...environmentConfig,
        });
      }
    }
  });

  if (
    !affectedProjects ||
    affectedProjects.length === 0 ||
    deployMatrix.include.length === 0
  ) {
    deployMatrix.include.push({
      run: false,
      appName: 'SKIP',
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
    const deployConfig = getDeployConfig(project);

    if (deployConfig) {
      const { matrix, appName, appId, namespace } = deployConfig;
      if (matrix.ecsMatrix) {
        const environmentConfig = matrix.ecsMatrix.environments[environment];

        deployMatrix.include.push({
          run: true,
          appName,
          appId,
          namespace,
          awsRegion: matrix.ecsMatrix.awsRegion,
          environment,
          ...environmentConfig,
        });
      }
    }
  });

  if (
    !affectedProjects ||
    affectedProjects.length === 0 ||
    deployMatrix.include.length === 0
  ) {
    deployMatrix.include.push({
      run: false,
      appName: 'SKIP',
    });
  }

  console.log('getECSMatrix:', deployMatrix);

  return deployMatrix;
};
