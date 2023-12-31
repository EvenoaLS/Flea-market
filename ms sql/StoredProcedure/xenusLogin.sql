--use Xenus
--exec xenusLogin 'xenus', 'password!'

Alter proc xenusLogin
	@loginId			varchar(50),
	@loginPassword		varchar(100)
as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY

		select	memIndex, id, name, memberType, email, lastLogin, regDate, modDate 
		from	member
		where	id = @loginID
		and		password = @loginPassword

		--접속기록	
		if (@@ROWCOUNT > 0)
			begin
				update member set lastLogin = getdate() where id = @loginID;
			end
	
		return 1;
	END TRY
	
	
	BEGIN CATCH
		return -1;
	END CATCH

--select * from member