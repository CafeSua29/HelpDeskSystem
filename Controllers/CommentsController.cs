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
                .Where(x => x.TicketId == id && x.DelTime == null)
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

                return RedirectToAction("TicketComments", new { id = comment.TicketId });
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

                return RedirectToAction("TicketComments", new { id = comment.TicketId });
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
                }

                await _context.MySaveChangesAsync(userId);
            }
            catch (Exception ex)
            {
                ElmahExtensions.RaiseError(ex);
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("TicketComments", new { id = comment.TicketId });
        }

        private bool CommentExists(int id)
        {
            return _context.Comments.Any(e => e.Id == id && e.DelTime == null);
        }

        public int CountComment(int id)
        {
            return _context.Comments.Where(x => x.TicketId == id && x.DelTime == null).Count();
        }
    }
}
