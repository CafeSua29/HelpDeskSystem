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
using HelpDeskSystem.ViewModels;

namespace HelpDeskSystem.Controllers
{
    public class TicketsController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public TicketsController(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        // GET: Tickets
        public async Task<IActionResult> Index()
        {
            var tickets = await _context.Tickets
                .Include(c => c.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            List<TicketVM> ticketVMs = new List<TicketVM>();

            foreach (var ticket in tickets)
            {
                TicketVM ticketVM = new TicketVM();

                ticketVM.Ticket = ticket;

                ticketVM.Comments = _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == ticket.Id)
                .Count();

                ticketVMs.Add(ticketVM);
            }

            return View(ticketVMs);
        }

        // GET: Tickets/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus"), "Id", "Description");

            return View(ticket);
        }

        // GET: Tickets/Create
        public IActionResult Create()
        {
            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");
            return View();
        }

        // POST: Tickets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Ticket ticket, IFormFile attachment)
        {
            if(attachment != null && attachment.Length > 0)
            {
                var filename = "Ticket_Attachment_" + DateTime.Now.ToString("yyyyMMdd") + "_" + attachment.FileName;

                var path = _configuration["FileSettings:UploadsFolder"];
                var filepath = Path.Combine(path, filename);

                var stream = new FileStream(filepath, FileMode.Create);
                await attachment.CopyToAsync(stream);
                ticket.Attachment = filename;
            }

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            ticket.CreatedOn = DateTime.Now;
            ticket.CreatedById = userId;

            _context.Add(ticket);
            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "Create",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "Tickets",
                AffectedTable = "Tickets"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            TempData["Message"] = "Ticket Created";

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            return RedirectToAction(nameof(Index));

            ViewData["CreatedById"] = new SelectList(_context.Users, "Id", "Name", ticket.CreatedById);
            return View(ticket);
        }

        // GET: Tickets/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets.FindAsync(id);
            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            return View(ticket);
        }

        // POST: Tickets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Ticket ticket, IFormFile attachment)
        {
            if (id != ticket.Id)
            {
                return NotFound();
            }

            try
            {
                if (attachment.Length > 0)
                {
                    var filename = "Ticket_Attachment_" + DateTime.Now.ToString("yyyyMMdd") + "_" + attachment.FileName;

                    var path = _configuration["FileSettings:UploadsFolder"];
                    var filepath = Path.Combine(path, filename);

                    var stream = new FileStream(filepath, FileMode.Create);
                    await attachment.CopyToAsync(stream);
                    ticket.Attachment = filename;
                }

                _context.Update(ticket);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TicketExists(ticket.Id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            ViewData["PriorityId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Priority"), "Id", "Description");
            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "Status"), "Id", "Description");
            ViewData["CategoryId"] = new SelectList(_context.TicketCategories, "Id", "Name");

            return RedirectToAction(nameof(Index));

            ViewData["CreatedById"] = new SelectList(_context.Users, "Id", "Name", ticket.CreatedById);
            return View(ticket);
        }

        // GET: Tickets/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (ticket == null)
            {
                return NotFound();
            }

            return View(ticket);

            //ticket = await _context.Tickets.FindAsync(id);
            //if (ticket != null)
            //{
            //    _context.Tickets.Remove(ticket);
            //}

            //await _context.SaveChangesAsync();

            //TempData["Message"] = "Ticket Deleted";

            //return RedirectToAction(nameof(Index));
        }

        // POST: Tickets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var ticket = await _context.Tickets.FindAsync(id);
            if (ticket != null)
            {
                _context.Tickets.Remove(ticket);
            }

            await _context.SaveChangesAsync();

            TempData["Message"] = "Ticket Deleted";

            return RedirectToAction(nameof(Index));
        }

        private bool TicketExists(int id)
        {
            return _context.Tickets.Any(e => e.Id == id);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddComment(int id, string Desc)
        {
            Comment comment = new Comment();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            comment.CreatedOn = DateTime.Now;
            comment.CreatedById = userId;
            comment.Id = 0;
            comment.TicketId = id;
            comment.Description = Desc;

            _context.Add(comment);
            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "Comment",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "Comments",
                AffectedTable = "Comments"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            return RedirectToAction("Details", new { id = id });

            ViewData["CreatedById"] = new SelectList(_context.Users, "Id", "Name", comment.CreatedById);
            ViewData["TicketId"] = new SelectList(_context.Tickets, "Id", "Title", comment.TicketId);
            return View(comment);
        }
        public async Task<IActionResult> Resolve(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["StatusId"] = new SelectList(_context.SystemCodeDetails.Include(x => x.SystemCode).Where(x => x.SystemCode.Code == "ResolutionStatus"), "Id", "Description");

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResolveConfirm(int id, string Desc, int StatusId)
        {
            TicketResolution resolution = new TicketResolution();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            resolution.CreatedOn = DateTime.Now;
            resolution.CreatedById = userId;
            resolution.Id = 0;
            resolution.TicketId = id;
            resolution.Description = Desc;
            resolution.StatusId = StatusId;

            _context.Add(resolution);

            var ticket = await _context.Tickets.FindAsync(id);
            ticket.StatusId = StatusId;

            _context.Update(ticket);

            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "ResolveConfirm",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "TicketResolutions",
                AffectedTable = "TicketResolutions"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            return RedirectToAction("Resolve", new { id = id });

            return View(resolution);
        }

        public async Task<IActionResult> Close(int id)
        {
            var closedstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "Status" && c.Code == "Closed")
                .FirstOrDefaultAsync();

            TicketResolution resolution = new TicketResolution();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            resolution.CreatedOn = DateTime.Now;
            resolution.CreatedById = userId;
            resolution.Id = 0;
            resolution.TicketId = id;
            resolution.Description = "Closed by owner";
            resolution.StatusId = closedstatusid.Id;

            _context.Add(resolution);

            var ticket = await _context.Tickets.FindAsync(id);
            ticket.StatusId = closedstatusid.Id;

            _context.Update(ticket);

            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "Close",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "TicketResolutions",
                AffectedTable = "TicketResolutions"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            return RedirectToAction("Index");

            return View(resolution);
        }

        public async Task<IActionResult> ReOpen(int id)
        {
            var pendingstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "Status" && c.Code == "Pending")
                .FirstOrDefaultAsync();

            TicketResolution resolution = new TicketResolution();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            resolution.CreatedOn = DateTime.Now;
            resolution.CreatedById = userId;
            resolution.Id = 0;
            resolution.TicketId = id;
            resolution.Description = "Re-open by owner";
            resolution.StatusId = pendingstatusid.Id;

            _context.Add(resolution);

            var ticket = await _context.Tickets.FindAsync(id);
            ticket.StatusId = pendingstatusid.Id;

            _context.Update(ticket);

            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "ReOpen",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "TicketResolutions",
                AffectedTable = "TicketResolutions"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            return RedirectToAction("Resolve", new { id = id });

            return View(resolution);
        }

        public async Task<IActionResult> Assign(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var ticket = await _context.Tickets
                .Include(t => t.CreatedBy)
                .Include(c => c.Status)
                .Include(c => c.Priority)
                .Include(t => t.SubCategory)
                .Include(t => t.AssignedTo)
                .FirstOrDefaultAsync(m => m.Id == id);

            ViewBag.Comments = await _context.Comments
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            ViewBag.Resolutions = await _context.TicketResolutions
                .Include(c => c.CreatedBy)
                .Include(c => c.Ticket)
                .Include(c => c.Status)
                .Where(c => c.TicketId == id)
                .OrderByDescending(c => c.CreatedOn)
                .ToListAsync();

            if (ticket == null)
            {
                return NotFound();
            }

            ViewData["UsersId"] = new SelectList(_context.Users, "Id", "Name");

            return View(ticket);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AssignConfirm(int id, string UserId)
        {
            TicketResolution resolution = new TicketResolution();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var user = await _context.Users.FindAsync(UserId);

            var assignedstatusid = await _context.SystemCodeDetails
                .Include(c => c.SystemCode)
                .Where(c => c.SystemCode.Code == "Status" && c.Code == "Assigned")
                .FirstOrDefaultAsync();

            resolution.CreatedOn = DateTime.Now;
            resolution.CreatedById = userId;
            resolution.Id = 0;
            resolution.TicketId = id;
            resolution.Description = "Assign to user " + user.Name;
            resolution.StatusId = assignedstatusid.Id;

            _context.Add(resolution);

            var ticket = await _context.Tickets.FindAsync(id);

            ticket.AssignedToId = UserId;
            ticket.AssignedTo = user;
            ticket.AssignedOn = DateTime.Now;
            ticket.StatusId = assignedstatusid.Id;

            _context.Update(ticket);

            await _context.SaveChangesAsync();

            //log the audit trail
            var activity = new AuditTrail
            {
                Action = "AssignConfirm",
                TimeStamp = DateTime.Now,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserId = userId,
                Module = "TicketResolutions",
                AffectedTable = "TicketResolutions"
            };

            _context.Add(activity);
            await _context.SaveChangesAsync();

            return RedirectToAction("Assign", new { id = id });

            return View(resolution);
        }
    }
}
