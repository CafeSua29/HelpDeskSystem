using DocumentFormat.OpenXml.Office2010.Excel;
using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Controllers
{
    public class RepliesController : Controller
    {
        private static readonly ApplicationDbContext _context;

        public static List<Reply> GetRepliesbyUserId(string userid)
        {
            var replies = _context.Replies
                .Where(x => x.ReplyToUserId == userid)
                .Include(c => c.UserReply)
                .Include(c => c.ReplyToUser)
                .Include(c => c.Ticket)
                .Include(c => c.Comment)
                .OrderByDescending(c => c.ReplyOn)
                .ToList();

            if (replies == null || replies.Count == 0)
            {
                replies = new List<Reply>();
            }

            return replies;
        }

        public void DeleteRepliesbyUserId(string userid)
        {
            var replies = _context.Replies.Where(x => x.ReplyToUserId == userid).ToList();

            try
            {
                foreach (var reply in replies)
                {

                }
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }
        }
    }
}
