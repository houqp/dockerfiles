#!/bin/bash
CI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python "${CI_DIR}"

def find_changed_dockerfiles():
    build_num = os.environ.get('CIRCLE_BUILD_NUM')

    info_api = 'https://circleci.com/api/v1.1/project/github/%s/%s/%s' % (
        os.environ.get('CIRCLE_PROJECT_USERNAME'),
        os.environ.get('CIRCLE_PROJECT_REPONAME'),
        build_num
    )

    # print('Fetching build info from %s...' % info_api)
    re = requests.get(info_api)
    if re.status_code != 200:
        sys.exit('Failed to fetch metadata for current build!')

    build_info = re.json()

    git_compare = build_info['compare'].split('/')[-1]

    changed_dockerfiles = []

    # print('List of changed files since last push (%s):' % git_compare)
    for l in ex('git diff --name-only %s' % git_compare).stdout().split():
        # print(l)
        if 'Dockerfile' in l:
            changed_dockerfiles.append(l)

    changed_dockerfiles.sort()
    return changed_dockerfiles



for dockerfile_path in find_changed_dockerfiles():
    docker_tag = gen_tag_from_filepath(dockerfile_path)
    if not docker_tag:
        print('Skipping %s due to reasons...' % dockerfile_path)
        continue

    print('--------------------------------------------')
    print('[*] Building %s with tag %s...' % (dockerfile_path, docker_tag))
    print('--------------------------------------------')
    call('docker build -t %s -f %s .' % (docker_tag, dockerfile_path),
         shell=True)


print(ex('docker images').stdout())
