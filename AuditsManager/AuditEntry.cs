using HelpDeskSystem.Models;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Newtonsoft.Json;

namespace HelpDeskSystem.AuditsManager
{
    public class AuditEntry : SystemLog
    {
        public EntityEntry Entry { get; set; }

        public string UserId { get; set; }

        public AppUser User { get; set; }

        public string Module { get; set; }

        public string IpAddress { get; set; }

        public string AffectedTable { get; set; }

        public Dictionary<string, object> KeyValues { get; set; } = new Dictionary<string, object>();

        public Dictionary<string, object> OldValues { get; set; } = new Dictionary<string, object>();

        public Dictionary<string, object> NewValues { get; set; } = new Dictionary<string, object>();

        public AuditType AuditType { get; set; }

        public List<string> AffectedColumns { get; } = new List<string>();

        public AuditTrail ToAudit()
        {
            var audit = new AuditTrail();

            audit.UserId = UserId;
            audit.Action = AuditType.ToString();
            audit.Module = Module;
            //audit.IpAddress = IpAddress;
            audit.AffectedTable = AffectedTable;
            audit.TimeStamp = DateTime.Now;
            audit.PrimaryKey = JsonConvert.SerializeObject(KeyValues);
            audit.OldValues = OldValues.Count == 0 ? null : JsonConvert.SerializeObject(OldValues);
            audit.NewValues = NewValues.Count == 0 ? null : JsonConvert.SerializeObject(NewValues);
            audit.AffectedColumns = AffectedColumns.Count == 0 ? null : JsonConvert.SerializeObject(AffectedColumns);

            return audit;
        }

        public AuditEntry(EntityEntry entry)
        {
            Entry = entry;
        }
    }
}
