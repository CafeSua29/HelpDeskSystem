namespace HelpDeskSystem.Models
{
    public class SystemTask : UserActivity
    {
        public int Id { get; set; }

        public int? ParentId { get; set; }

        public SystemTask? Parent { get; set; }

        public string Code { get; set; }

        public string Name { get; set; }

        public ICollection<SystemTask>? ChildTasks { get; set; }

        public int? OrderNo { get; set; }
    }
}
