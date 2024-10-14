using Quartz;

namespace HelpDeskSystem.Services
{
    public class JobReminders : IJob
    {
        public JobReminders()
        {
            
        }

        public Task Execute(IJobExecutionContext context)
        {
            return Task.CompletedTask;
        }
    }
}
