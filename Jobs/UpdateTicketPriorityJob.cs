using ElmahCore;
using HelpDeskSystem.Data;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace HelpDeskSystem.Jobs
{
    public class UpdateTicketPriorityJob : IJob
    {
        private readonly ApplicationDbContext _context;

        public UpdateTicketPriorityJob(ApplicationDbContext context)
        {
            _context = context;
        }

        private async Task UpdatePriority()
        {
            try
            {
                var tickets = await _context.Tickets
                   .Where(t => t.DelTime == null)
                   .ToListAsync();

                var ss = await _context.SystemSettings
                    .Where(x => x.Code == "TicketResolutionDays" && x.DelTime == null)
                    .FirstOrDefaultAsync();

                var duration = ss.Value;

                var lowpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Priority" && c.Code == "Low" && c.DelTime == null)
                    .FirstOrDefaultAsync();

                var mediumpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Priority" && c.Code == "Medium" && c.DelTime == null)
                    .FirstOrDefaultAsync();

                var highpriorityid = await _context.SystemCodeDetails
                    .Include(c => c.SystemCode)
                    .Where(c => c.SystemCode.Code == "Priority" && c.Code == "High" && c.DelTime == null)
                    .FirstOrDefaultAsync();

                foreach (var ticket in tickets)
                {
                    if (ticket.Duration <= duration)
                        ticket.PriorityId = lowpriorityid.Id;
                    else if (ticket.Duration <= duration * 2)
                        ticket.PriorityId = mediumpriorityid.Id;
                    else
                        ticket.PriorityId = highpriorityid.Id;
                    _context.Update(ticket);
                }

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
            }
        }

        public async Task Execute(IJobExecutionContext context)
        {
            try
            {
                await UpdatePriority();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
            }
        }
    }
}
