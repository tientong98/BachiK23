#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep  1 16:10:01 2021

@author: TienTong
"""

import argparse
import flywheel
import logging

# Instantiate a logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
log = logging.getLogger('root')

def run_gear(gear, inputs, dest):
    """Submits a job with specified gear and inputs.

    Args:
        gear (flywheel.Gear): A Flywheel Gear.
        inputs (dict): Input dictionary for the gear.
        dest (flywheel.container): A Flywheel Container where the output will be stored.

    Returns:
        str: The id of the submitted job.

    """
    try:
        # Run the gear on the inputs provided, stored output in dest constainer and returns job ID
        gear_job_id = gear.run(inputs=inputs, destination=dest)
        log.debug('Submitted job %s', gear_job_id)
        return gear_job_id
    except flywheel.rest.ApiException:
        log.exception('An exception was raised when attempting to submit a job for %s',
                      file_obj.name)

def parse_cmdline():
        # Make parser object
    parser = argparse.ArgumentParser(description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    # Required arguments
    parser.add_argument("-p", "--project_name", type=str,
                        required=True, dest='project_name',
                        help="specify the flywheel project")
    parser.add_argument("-s", "--subject_id", type=str,
                        required=True, dest='subject_id',
                        help="specify the subject id")
    parser.add_argument("-m", "--modality", type=str,
                    required=True, dest='modality', choices=['anat', 'func'],
                    help="specify the modality to run MRIQC, anat for func")
    parser.add_argument("-t", "--task", type=str, default=None,
                    dest='task', help="specify the task to run MRIQC")
    return(parser)

def main():
    args = parse_cmdline().parse_args()
    project_name = args.project_name
    subject_id = args.subject_id
    modality = args.modality
    if modality == 'func':
        task = args.task

    fw = flywheel.Client()
    project = fw.projects.find_one('label='+project_name)
    mriqc_gear = fw.gears.find_first('gear.name=mriqc')

    # Initialize mriqc_job_list
    mriqc_job_list = list()
    # Iterate over project sessions
    for session in project.sessions.iter():
        # Iterate over sessions acquisition
        if modality == 'func':
            for acq_obj in session.acquisitions.find('files.info.BIDS.Task=' +
                                             task +
                                             ',files.info.BIDS.Path=' +
                                             subject_id + '/func' +
                                             ',files.info.BIDS.Modality!=sbref' +
                                             ',files.type=nifti'):
                for file_obj in acq_obj.files:
                    inputs = {'nifti':file_obj}
                    dest = file_obj.parent
                    job_id = run_gear(mriqc_gear, inputs, dest)
                    mriqc_job_list.append(job_id)
                    print('Submitting MRIQC job for', file_obj.name)
        if modality == 'anat':
            for acq_obj in session.acquisitions.find(
                                             'files.info.BIDS.Path=' +
                                             subject_id + '/anat' +
                                             ',files.type=nifti'):
                for file_obj in acq_obj.files:
                    inputs = {'nifti':file_obj}
                    dest = file_obj.parent
                    job_id = run_gear(mriqc_gear, inputs, dest)
                    mriqc_job_list.append(job_id)
                    print('Submitting MRIQC job for', file_obj.name)

if __name__ == "__main__":
    main()
