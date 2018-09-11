  export class SuccessResult {
    constructor(readonly projectId: string) {}
  }
  
  export interface ISharedUser {
    readonly userId: string;
    readonly twitterId: string;
    readonly sharedAt: Date;
  }
  
  export class SharedUser implements ISharedUser {
    constructor(
      readonly userId: string, 
      readonly twitterId: string,
      readonly sharedAt: Date) {}
  }
  
  export interface IInvitation {
    readonly projectId: string;
  }

  export interface IProject {
    readonly ownerUserId: string;
  }