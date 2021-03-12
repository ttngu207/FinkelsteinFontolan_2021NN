"""This module was auto-generated by datajoint from an existing schema"""


import datajoint as dj

schema = dj.Schema('arseny_s1alm')





@schema
class TrainingType(dj.Lookup):
    definition = """
    # Mouse training
    training_type        : varchar(40)                  # mouse training
    """


@schema
class TaskType(dj.Lookup):
    definition = """
    # Type of tasks
    task_name            : varchar(40)                  # task type
    """


@schema
class StrainType(dj.Lookup):
    definition = """
    # Mouse strain
    strain               : varchar(30)                  # mouse strain
    """


@schema
class S1StimType(dj.Lookup):
    definition = """
    # S1StimType
    stim_type="nostim"   : varchar(12)                  # sample or distractor or no-stim
    """


@schema
class S1StimPowerType(dj.Lookup):
    definition = """
    # S1StimPowerType    - full or mini
    stim_power_type="none" : varchar(12)                  # stim power category (e.g. full or mini)
    """


@schema
class OutcomeType(dj.Lookup):
    definition = """
    # Outcome
    outcome              : varchar(12)                  # outcome code, non-mutually exclusive
    """


@schema
class InstructionType(dj.Lookup):
    definition = """
    # Instruction
    instruction          : varchar(12)                  # instruction - where to lick (e.g. lick right) mutually exclusive
    """


@schema
class GeneModType(dj.Lookup):
    definition = """
    gene_modification    : varchar(120)                 
    """


@schema
class Animal(dj.Manual):
    definition = """
    # Experiment subjects
    animal_id            : int                          # animal id
    ---
    species              : varchar(255)                 
    date_of_birth        : date                         
    -> StrainType
    -> GeneModType
    """


@schema
class Session(dj.Manual):
    definition = """
    # A recording session
    -> Animal
    session_id           : tinyint                      # session id
    ---
    session_date         : date                         # date on which the session was begun
    session_suffix       : char(1)                      # suffix distinguishing sessions on the same date
    processed_dir        : varchar(255)                 # processed session data directory
    session_file         : varchar(255)                 # the session file name
    video_dir            : varchar(255)                 # video file
    """


    class Type(dj.Part):
        definition = """
        # SessionType
        -> Session
        -> ExperimentType
        """


@schema
class ExtracelProbe(dj.Manual):
    definition = """
    # ExtracelProbe recording info
    -> Session
    ---
    recording_hemisphere : varchar(8)                   
    recording_brain_area : varchar(32)                  
    recording_coords_x=null : float                        # Medio-Lateral
    recording_coords_y=null : float                        # Posterior-Anterior
    recording_coords_z=null : float                        # depth (Dorsal-Ventral)
    probe_type           : varchar(60)                  
    probe_id             : varchar(60)                  
    spike_sorting        : varchar(16)                  
    sampling_fq          : float                        # DAQ sampling frequeny
    """


@schema
class UnitExtracel(dj.Imported):
    definition = """
    -> ExtracelProbe
    unit_id              : smallint                     # unit_id unique across sessions
    ---
    unit_num             : smallint                     # unit_num within a session (not unique across sessions) - corresponds to the cluster number from the spikesorting
    unit_x=null          : float                        # unit coordinate Medio-Lateral
    unit_y=null          : float                        # unit coordinate Posterior-Anterior
    unit_z=null          : float                        # unit depth
    unit_quality=null    : float                        # unit quality; 2 - single unit; 1 - probably single unit; 0 - multiunit
    unit_channel=null    : float                        # channel on the probe for each the unit has the largest amplitude (verify that its based on amplitude or other feature)
    avg_waveform=null    : longblob                     # unit average waveform, each point corresponds to a sample. (what are the amplitude units?)  To convert into time use the sampling_frequency.
    """


@schema
class Behavior(dj.Manual):
    definition = """
    # Behavior
    -> Session
    ---
    -> TaskType
    task_subtype         : tinyint                      # task
    -> TrainingType
    """


@schema
class Trial(dj.Imported):
    definition = """
    -> Behavior
    trial_id             : int                          # trial_id unique across sessions
    ---
    trial_num            : smallint                     # trial number within a session (not unique across sessions). If behavior is aquired together with ephys recording, only trials with ephys recording would be saved (to think if we want to change it and get all trials, even those for each the ephys is missing)
    -> InstructionType
    trial_type_name      : varchar(64)                  # trial type name  (e.g. r_s_Stim1700Eps2600)
    start_time           : double                       # relative to beginning of the data aquisition for the entire session
    cue_time=null        : double                       # relative to the beginning of each trial
    """

    class Video(dj.Part):
        definition = """
        # TrialVideo  if there are more than one camera, each camera would have a separate entry
        -> Trial
        video_id             : int                          # video_id unique across sessions
        ---
        video_flag=0         : tinyint                      # flag indicating if there is a video or not
        camera_id=null       : tinyint                      # camera id
        video_file_name=null : varchar(255)                 # video file
        """


    class S1Photostim(dj.Part):
        definition = """
        # TrialS1Photostim
        -> Trial
        stim_onset           : decimal(6,3)                 # onset of the stimulation relative to the go-cue (s)
        ---
        -> S1StimType
        -> S1StimPowerType
        stim_power=null      : double                       # laser power (mW)
        stim_total_durat=null : double                       # total stimulation duration (s)
        stim_pulse_num=null  : tinyint                      # number of pulses
        stim_pulse_durat=null : double                       # pulse duration (s)
        """


    class Outcome(dj.Part):
        definition = """
        # TrialOutcome
        -> Trial
        -> OutcomeType
        """


    class Licks(dj.Part):
        definition = """
        # TrialLicks
        -> Trial
        lick_side            : enum('left','right')         
        ---
        lick_times           : longblob                     
        """


@schema
class TrialSpikes(dj.Imported):
    definition = """
    -> UnitExtracel
    -> Trial
    ---
    spike_times          : longblob                     # spike times for each trial (relative to the beginning of the trial)
    """


@schema
class ExperimentType(dj.Lookup):
    definition = """
    # Possible types of experiment (e.g. behavior, ephys, etc)
    experiment_type      : varchar(40)                  
    """