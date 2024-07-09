Config = {}
   
    

Config.MaxTotalJobs = 3     --Total allowed jobs (nil for as many as you want)
Config.MaxGovtJobs = 1      --Government jobs allowed (like doc or popo etc) - nil for no limit up to maxtotaljobs
Config.GovtJobs = {"medical", "police", "undertaker", "doj", "engineer"}
Config.unemployedJob = "unemployed"
Config.Command= 'jobs'

Config.Languages = {
    savedJob = "Job Saved",
    jobNotSaved = "Job not saved",
    tooManyJobs = "You have too many jobs to add that one. Quit one and try again.",
    tooManyGovtJobs = "You have too many government jobs.",
    youquit = "You quit your job!",
    unable = "Unable to retrieve job data",
    switchedTo = "Switched to "
    

}

Config.Webhooks={
    URL ='',
    Color = '16711680',
    WebhookName = 'Job Bot',
    WebhookLogo = '32x32'
}
