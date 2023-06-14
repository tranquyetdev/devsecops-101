// Get affected tests
// npx nx show projects --with-target test --affected --base=NX_BASE --head=NX_HEAD
export function getAffectedTest() {
  return String(process.env.NX_AFFECTED_TEST).split('\n');
}

// Get affected build
// npx nx show projects --with-target build --affected --base=NX_BASE --head=NX_HEAD
export function getAffectedBuild() {
  // extract multiline string from env
  return String(process.env.NX_AFFECTED_BUILD).split('\n');
}
