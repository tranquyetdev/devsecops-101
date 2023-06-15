export interface IDeployConfig {
  projectId: string;
  matrix: Record<string, any>;
}

export type DeployMatrixAction = 'test' | 'build';

export interface IDeployMatrixActionConfig {
  run: boolean;
  name: string;
}

export interface IDeployMatrix {
  ecsMatrix: {
    include: IDeployMatrixActionConfig[];
  } | null;
  cloudfrontMatrix: {
    include: IDeployMatrixActionConfig[];
  } | null;
}

export const getDeployConfig = (projectId: string): IDeployConfig => {
  const deployConfig = require(`../../apps/${projectId}/deploy.json`);
  return deployConfig;
};
