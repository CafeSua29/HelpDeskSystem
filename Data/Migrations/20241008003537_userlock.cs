using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HelpDeskSystem.Data.Migrations
{
    /// <inheritdoc />
    public partial class userlock : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                table: "AspNetRoleClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                table: "AspNetUserClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                table: "AspNetUserLogins");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                table: "AspNetUserRoles");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                table: "AspNetUserRoles");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                table: "AspNetUserTokens");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditTrails_AspNetUsers_UserId",
                table: "AuditTrails");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemSettings_AspNetUsers_CreatedById",
                table: "SystemSettings");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemSettings_AspNetUsers_ModifiedById",
                table: "SystemSettings");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemTasks_SystemTasks_ParentId",
                table: "SystemTasks");

            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_CreatedById",
                table: "TicketResolutions");

            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_ModifiedById",
                table: "TicketResolutions");

            migrationBuilder.DropForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetRoles_RoleId",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_CreatedById",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_ModifiedById",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_SystemTasks_TaskId",
                table: "UserRoleProfiles");

            migrationBuilder.AddColumn<bool>(
                name: "IsLocked",
                table: "AspNetUsers",
                type: "bit",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                table: "AspNetUserClaims",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                table: "AspNetUserLogins",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                table: "AspNetUserRoles",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                table: "AspNetUserTokens",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditTrails_AspNetUsers_UserId",
                table: "AuditTrails",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SystemSettings_AspNetUsers_CreatedById",
                table: "SystemSettings",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SystemSettings_AspNetUsers_ModifiedById",
                table: "SystemSettings",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SystemTasks_SystemTasks_ParentId",
                table: "SystemTasks",
                column: "ParentId",
                principalTable: "SystemTasks",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_CreatedById",
                table: "TicketResolutions",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_ModifiedById",
                table: "TicketResolutions",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets",
                column: "SubCategoryId",
                principalTable: "TicketSubCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetRoles_RoleId",
                table: "UserRoleProfiles",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_CreatedById",
                table: "UserRoleProfiles",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_ModifiedById",
                table: "UserRoleProfiles",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_SystemTasks_TaskId",
                table: "UserRoleProfiles",
                column: "TaskId",
                principalTable: "SystemTasks",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                table: "AspNetRoleClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                table: "AspNetUserClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                table: "AspNetUserLogins");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                table: "AspNetUserRoles");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                table: "AspNetUserRoles");

            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                table: "AspNetUserTokens");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditTrails_AspNetUsers_UserId",
                table: "AuditTrails");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemSettings_AspNetUsers_CreatedById",
                table: "SystemSettings");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemSettings_AspNetUsers_ModifiedById",
                table: "SystemSettings");

            migrationBuilder.DropForeignKey(
                name: "FK_SystemTasks_SystemTasks_ParentId",
                table: "SystemTasks");

            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_CreatedById",
                table: "TicketResolutions");

            migrationBuilder.DropForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_ModifiedById",
                table: "TicketResolutions");

            migrationBuilder.DropForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetRoles_RoleId",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_CreatedById",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_ModifiedById",
                table: "UserRoleProfiles");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRoleProfiles_SystemTasks_TaskId",
                table: "UserRoleProfiles");

            migrationBuilder.DropColumn(
                name: "IsLocked",
                table: "AspNetUsers");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                table: "AspNetUserClaims",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                table: "AspNetUserLogins",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                table: "AspNetUserRoles",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                table: "AspNetUserTokens",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditTrails_AspNetUsers_UserId",
                table: "AuditTrails",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SystemSettings_AspNetUsers_CreatedById",
                table: "SystemSettings",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SystemSettings_AspNetUsers_ModifiedById",
                table: "SystemSettings",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_SystemTasks_SystemTasks_ParentId",
                table: "SystemTasks",
                column: "ParentId",
                principalTable: "SystemTasks",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_CreatedById",
                table: "TicketResolutions",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_TicketResolutions_AspNetUsers_ModifiedById",
                table: "TicketResolutions",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Tickets_TicketSubCategories_SubCategoryId",
                table: "Tickets",
                column: "SubCategoryId",
                principalTable: "TicketSubCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetRoles_RoleId",
                table: "UserRoleProfiles",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_CreatedById",
                table: "UserRoleProfiles",
                column: "CreatedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_AspNetUsers_ModifiedById",
                table: "UserRoleProfiles",
                column: "ModifiedById",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserRoleProfiles_SystemTasks_TaskId",
                table: "UserRoleProfiles",
                column: "TaskId",
                principalTable: "SystemTasks",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
