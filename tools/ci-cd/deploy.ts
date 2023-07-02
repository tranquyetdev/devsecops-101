export interface IDeployConfig {
  namespace: string;
  appName: string;
  appId: string;
  matrix: Record<string, any>;
}

export interface IDeployMatrixActionConfig {
  run: boolean;
  appName: string;
}

export interface IDeployMatrix {
  include: IDeployMatrixActionConfig[];
}

/**
 * Get app deployment configuration
 *
 * @param appName Application name
 * @returns deployment configuration
 */
export const getDeployConfig = (appName: string): IDeployConfig | null => {
  try {
    const deployConfig = require(`../../apps/${appName}/deploy.json`);
    return deployConfig;
  } catch (e) {
    console.log(`No deploy config found for app ${appName}`);
    return null;
  }
};
