// Get affected build
// npx nx show projects --with-target build --affected --base=NX_BASE --head=NX_HEAD
export function getAffectedBuild() {
  // extract multiline string from env
  return String(process.env.NX_AFFECTED_BUILD)
    .split('\n')
    .filter((project) => project.length > 0);
}
