#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
from subprocess import check_call
from floydker.utils import assert_image_tag_from_dockerfile

import logging
logger = logging.getLogger(__name__)

if len(sys.argv) <= 1:
    sys.exit('USAGE %s DOCKERFILE_PATH' % (sys.argv[0]))

image_tag = assert_image_tag_from_dockerfile(logger, sys.argv[1])
if not image_tag:
    sys.exit('ERROR: not able to generate tag from %s' % (sys.argv[1]))

image_save_path = './ci/output/%s' % image_tag.split('/')[-1]
print '[*] Saving image to %s...' % (image_save_path)
check_call(['docker', 'save', '-o', image_save_path, image_tag])
