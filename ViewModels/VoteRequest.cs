namespace HelpDeskSystem.ViewModels
{
    public class VoteRequest
    {
        public int CommentId { get; set; }
        public int VoteValue { get; set; } // 1 for upvote, -1 for downvote
    }
}
