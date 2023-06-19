import * as core from '@actions/core';
import isCI from 'is-ci';

/**
 * Set Gihub action output
 *
 * @param name output name
 * @param value output value
 * @returns void
 */
export const setOutput = (name: string, value: any) => {
  const output = JSON.stringify(value || { run: false, name: 'SKIP' });
  if (isCI) {
    core.setOutput(`${name}`, `${output}`);
  } else {
    console.log(`${name}=${output}`);
  }
};

/**
 * Get current environment based on branch name
 *
 * @param branch branch name
 * @returns environment name
 */
export const getEnvironment = (branch: string) => {
  return 'preview';
};

/**
 * Get NX affected:build projects
 * npx nx show projects --with-target build --affected --base=NX_BASE --head=NX_HEAD
 *
 * @returns affected projects
 */
export const getAffectedProjects = (): string[] => {
  return String(process.env.NX_AFFECTED_BUILD)
    .split('\n')
    .filter((project) => project && project.length > 0);
};
