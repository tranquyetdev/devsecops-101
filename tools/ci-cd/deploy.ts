export interface IDeployConfig {
  appId: string
  matrix: Record<string, any>
}

export const getDeployConfig = (appId: string): IDeployConfig => {
  const deployConfig = require(`../../apps/${appId}/deploy.json`)
  return deployConfig
}
