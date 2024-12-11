using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using HelpDeskSystem.Data;
using HelpDeskSystem.Models;
using System.Security.Claims;
using HelpDeskSystem.Data.Migrations;
using HelpDeskSystem.Services;
using Microsoft.AspNetCore.Authorization;
using HelpDeskSystem.ClaimsManagement;
using ElmahCore;
using System.Net.Mail;
using System.Xml.Linq;
using HelpDeskSystem.ViewModels;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Comment = HelpDeskSystem.Models.Comment;

namespace HelpDeskSystem.Controllers
{
    [Authorize]
    [Permission(":TICKETS")]
    public class CommentsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CommentsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Comments
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(t => t.DelTime == null);
            return View(await applicationDbContext.ToListAsync());
        }

        public async Task<IActionResult> TicketComments(int? id, string Desc, string CreatedById)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comments = _context.Comments
                .Where(x => x.TicketId == id && x.ReplyId == null && x.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderByDescending(c => c.CreatedOn)
                .AsQueryable();

            if (!string.IsNullOrEmpty(Desc))
            {
                comments = comments.Where(x => x.Description.Contains(Desc));
            }

            if (!string.IsNullOrEmpty(CreatedById))
            {
                comments = comments.Where(x => x.CreatedById == CreatedById);
            }

            ViewBag.TicketId = id;

            return View(await comments.ToListAsync());
        }

        // GET: Comments/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comment = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (comment == null)
            {
                return NotFound();
            }

            return View(comment);
        }

        // GET: Comments/Create
        public IActionResult Create(int id)
        {
            if (id == null)
            {
                return NotFound();
            }

            Comment comment = new Comment();
            comment.TicketId = id;

            return View(comment);
        }

        // POST: Comments/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Comment comment)
        {
            try
            {
                var userId = User.GetUserId();

                comment.CreatedOn = DateTime.Now;
                comment.CreatedById = userId;
                comment.Id = 0;

                _context.Add(comment);
                await _context.MySaveChangesAsync(userId);

                return RedirectToAction("Comment", "Tickets", new { id = comment.TicketId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(comment);
            }
        }

        // GET: Comments/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comment = await _context.Comments.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (comment == null)
            {
                return NotFound();
            }

            return View(comment);
        }

        // POST: Comments/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Comment comment)
        {
            if (id != comment.Id)
            {
                return NotFound();
            }

            try
            {
                var userId = User.GetUserId();

                comment.ModifiedOn = DateTime.Now;
                comment.ModifiedById = userId;

                _context.Update(comment);
                await _context.MySaveChangesAsync(userId);

                return RedirectToAction("Comment", "Tickets", new { id = comment.TicketId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(comment);
            }
        }

        // GET: Comments/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comment = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (comment == null)
            {
                return NotFound();
            }

            return View(comment);
        }

        // POST: Comments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var comment = await _context.Comments.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);

            try
            {
                var userId = User.GetUserId();

                if (comment != null)
                {
                    //_context.Comments.Remove(comment);

                    comment.DelTime = DateTime.Now;

                    _context.Update(comment);

                    var replies = _context.Comments.Where(x => x.ReplyId == id && x.DelTime == null).ToList();

                    foreach (var reply in replies)
                    {
                        reply.DelTime = DateTime.Now;

                        _context.Update(reply);
                    }
                }

                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("Comment", "Tickets", new { id = comment.TicketId });
        }

        private bool CommentExists(int id)
        {
            return _context.Comments.Any(e => e.Id == id && e.DelTime == null);
        }

        public int CountComment(int id)
        {
            return _context.Comments.Where(x => x.TicketId == id && x.DelTime == null).Count();
        }

        public async Task<IActionResult> ReplyComments(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comments = await _context.Comments
                .Where(e => e.ReplyId == id && e.DelTime == null)
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            ViewBag.ReplyId = id;

            return View(comments);
        }

        public async Task<IActionResult> Reply(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var comment = await _context.Comments.FirstOrDefaultAsync(e => e.Id == id && e.DelTime == null);
            if (comment == null)
            {
                return NotFound();
            }

            Comment replyComment = new Comment();
            replyComment.TicketId = comment.TicketId;
            replyComment.ReplyId = comment.Id;

            return View(replyComment);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reply(Comment comment)
        {
            try
            {
                var userId = User.GetUserId();

                comment.CreatedOn = DateTime.Now;
                comment.CreatedById = userId;
                comment.Id = 0;

                _context.Add(comment);
                await _context.MySaveChangesAsync(userId);

                return RedirectToAction("ReplyComments", new { id = comment.ReplyId });
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;

                return View(comment);
            }
        }

        [HttpPost]
        [Route("Comments/Vote")]
        public async Task<IActionResult> Vote([FromBody] VoteRequest request)
        {
            if (request == null || request.CommentId <= 0)
            {
                return BadRequest("Invalid request data.");
            }

            var userId = User.GetUserId();

            // Check if the user has already voted on this comment
            var existingVote = await _context.Votes.FirstOrDefaultAsync(v => v.CommentId == request.CommentId && v.UserId == userId);

            var comment = await _context.Comments.Include(c => c.CreatedBy).FirstOrDefaultAsync(c => c.Id == request.CommentId);

            if (comment == null)
            {
                return BadRequest("Comment not found.");
            }

            int newVoteValue = 0; // Default is no vote

            if (existingVote != null)
            {
                if (existingVote.Value == request.VoteValue)
                {
                    // Unvote if the same vote is clicked again
                    comment.VoteValue -= existingVote.Value;

                    comment.CreatedBy.Reputation -= request.VoteValue;

                    _context.Votes.Remove(existingVote);
                }
                else
                {
                    // Change the vote if it's different
                    comment.VoteValue -= existingVote.Value; // Revert the previous vote
                    comment.VoteValue += request.VoteValue;      // Apply the new vote

                    comment.CreatedBy.Reputation -= existingVote.Value;
                    comment.CreatedBy.Reputation += request.VoteValue;

                    existingVote.Value = request.VoteValue;

                    newVoteValue = request.VoteValue;
                }
            }
            else
            {
                // Add a new vote
                var vote = new Vote
                {
                    UserId = userId,
                    CommentId = request.CommentId,
                    Value = request.VoteValue
                };

                await _context.Votes.AddAsync(vote);

                comment.VoteValue += request.VoteValue;
                comment.CreatedBy.Reputation += request.VoteValue; // Update reputation

                newVoteValue = request.VoteValue;
            }

            try
            {
                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error updating database: {ex.Message}");
            }

            return Json(new { voteValue = comment.VoteValue, currentVote = newVoteValue });
        }

    }
}
