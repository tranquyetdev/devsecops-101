export interface IDeployConfig {
  projectId: string;
  matrix: Record<string, any>;
}

export interface IDeployMatrixActionConfig {
  run: boolean;
  name: string;
}

export interface IDeployMatrix {
  include: IDeployMatrixActionConfig[];
}

/**
 * Get project deployment configuration
 *
 * @param projectId project id
 * @returns deployment configuration
 */
export const getDeployConfig = (projectId: string): IDeployConfig | null => {
  try {
    const deployConfig = require(`../../apps/${projectId}/deploy.json`);
    return deployConfig;
  } catch (e) {
    console.log(`No deploy config found for project ${projectId}`);
    return null;
  }
};
