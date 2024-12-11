namespace HelpDeskSystem.Models
{
    public class Reply
    {
        public int Id { get; set; }

        public string Message { get; set; }

        public string UserIdReply { get; set; }

        public AppUser UserReply { get; set; }

        public string ReplyToUserId { get; set; }

        public AppUser ReplyToUser { get; set; }

        public int TicketId { get; set; }

        public Ticket Ticket { get; set; }

        public int? CommentId { get; set; }

        public Comment? Comment { get; set; }

        public DateTime ReplyOn { get; set; }

        public string NotiMsg { get; set; }
    }
}
