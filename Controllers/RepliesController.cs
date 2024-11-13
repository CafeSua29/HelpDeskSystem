using DocumentFormat.OpenXml.Office2010.Excel;
using ElmahCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HelpDeskSystem.Controllers
{
    public class RepliesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public RepliesController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        [Route("Replies/ClearRepliesAsync")]
        public async Task<IActionResult> ClearRepliesAsync(string userid)
        {
            var user = await _context.Users.FirstOrDefaultAsync(e => e.Id == userid && e.DelTime == null);
            var replies = await _context.Replies.Where(x => x.ReplyToUserId == userid).ToListAsync();

            try
            {
                foreach (var reply in replies)
                {
                    _context.Replies.Remove(reply);
                }

                user.Notification = 0;

                _context.Users.Update(user);

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
            }

            return Ok();
        }
    }
}
