import { Component } from '@angular/core';

@Component({
    selector: 'legacy-user-list',
    template: `
    <div class="user-list">
      <h2>User List (Legacy Angular)</h2>
      <ul>
        <li *ngFor="let user of users">{{ user.name }}</li>
      </ul>
    </div>
  `
})
export class LegacyUserListComponent {
    users = [
        { name: 'John Doe' },
        { name: 'Jane Smith' }
    ];

    constructor() {
        console.log('Legacy component initialized');
    }
}
