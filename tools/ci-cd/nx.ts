// Get affected tests
// npx nx show projects --with-target test --affected --base=NX_BASE --head=NX_HEAD
export function getAffectedTest() {
  console.log(process.env.NX_AFFECTED_TEST);
  return process.env.NX_AFFECTED_TEST;
}

// Get affected build
// npx nx show projects --with-target build --affected --base=NX_BASE --head=NX_HEAD
export function getAffectedBuild() {
  console.log(process.env.NX_AFFECTED_BUILD);
  return process.env.NX_AFFECTED_BUILD;
}
