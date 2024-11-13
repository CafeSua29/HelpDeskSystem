using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Interfaces;
using HelpDeskSystem.Models;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Services
{
    public class ReplyService : IListService
    {
        private readonly ApplicationDbContext _context;

        public ReplyService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Reply>> GetRepliesAsync(string userid)
        {
            var replies = await _context.Replies
                .Include(c => c.UserReply)
                .Include(c => c.ReplyToUser)
                .Include(c => c.Ticket)
                .Include(c => c.Comment)
                .Where(x => x.ReplyToUserId.Equals(userid))
                .OrderByDescending(c => c.ReplyOn)
                .ToListAsync();

            return replies;
        }
    }
}
