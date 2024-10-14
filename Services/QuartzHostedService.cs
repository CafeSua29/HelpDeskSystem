using Quartz;
using Quartz.Spi;

namespace HelpDeskSystem.Services
{
    public class QuartzHostedService : IHostedService
    {
        private readonly ISchedulerFactory _schedulerFactory;
        private readonly IJobFactory _jobFactory;
        private readonly IEnumerable<MyJob> _myJobs;

        public QuartzHostedService(ISchedulerFactory schedulerFactory, IJobFactory jobFactory, IEnumerable<MyJob> myJobs)
        {
            _jobFactory = jobFactory;
            _schedulerFactory = schedulerFactory;
            _myJobs = myJobs;
        }

        public IScheduler Scheduler { get; set; }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            Scheduler = await _schedulerFactory.GetScheduler(cancellationToken);
            Scheduler.JobFactory = _jobFactory;

            foreach (var myJob in _myJobs)
            {
                var job = CreateJob(myJob);

                var trigger = CreateTrigger(myJob);

                await Scheduler.ScheduleJob(job, trigger, cancellationToken);
            }

            await Scheduler.Start(cancellationToken);
        }

        public async Task StopAsync(CancellationToken cancellationToken)
        {
            await Scheduler?.Shutdown(cancellationToken);
        }

        private static IJobDetail CreateJob(MyJob myJob)
        {
            var type = myJob.Type;

            return JobBuilder.Create(type).WithIdentity(type.FullName).WithDescription(type.Name).Build();
        }

        private static ITrigger CreateTrigger(MyJob myJob)
        {
            return TriggerBuilder.Create().WithIdentity($"{myJob.Type.FullName}.trigger").WithCronSchedule(myJob.Expression).WithDescription(myJob.Expression).Build();
        }
    }
}
