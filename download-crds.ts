import child_process from 'node:child_process';
import { createHash } from 'node:crypto';
import * as fs from 'fs';
import { promisify } from 'node:util';
import YAML from 'yaml';

interface Provider {
  type_: string,
  name: string,
  version: string,
};

const exec = promisify(child_process.exec);

const providers: Provider[] = [
  { type_: 'core', name: 'cluster-api', version: 'v1.9.4' },
];

/**
 * Generate and return a provider install manifest.
 * YAML, multi-document
 */
const generateProviderInstall = async (p: Provider): Promise<any[]> => {
  const cmd = `clusterctl generate provider --${p.type_}=${p.name}:${p.version}`;
  const { stdout } = await exec(cmd);
  return YAML.parseAllDocuments(stdout).map((doc) => doc.toJS());
};

const main = async () => {
  const outRoot = './.temp/crds';

  providers.forEach(async (provider) => {
    (await generateProviderInstall(provider)).forEach((manifest) => {
      if (manifest.kind !== 'CustomResourceDefinition') return;

      let outFile = `${outRoot}/${manifest.metadata.name}.yaml`;
      const contents = YAML.stringify(manifest);

      if (fs.existsSync(outFile)) {
        console.error(`${outFile} already exists, saving with a .duplicate ext`);
        const hash = createHash('sha256');
        hash.update(contents);
        outFile = `${outFile}${hash.digest('hex')}.duplicate`;
      }

      fs.mkdirSync(outRoot, { recursive: true });
      fs.writeFileSync(outFile, contents);
      console.log(`written ${outFile}`);
    });
  });
};

main().catch(console.error);
