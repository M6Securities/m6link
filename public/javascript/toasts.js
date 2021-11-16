let numOfToasts = 0;

function createToast(title, content, type) {
    'use strict';

    if (toastr != undefined) {
        toastr.clear();

        // toastr.success('Have fun storming the castle!', 'Miracle Max Says');

        if(type === 'error') {
            toastr.error(content, title);
        } else if(type === 'warning') {
            toastr.warning(content, title);
        } else {
            toastr.success(content, title);
        }
    } else {
        numOfToasts++;
        let displayType = ``;

        if(type === "error") {
            displayType = `<strong class="me-auto text-danger">Error! ${title}</strong>`;
        } else if(type === "warning") {
            displayType = `<strong class="me-auto text-warning">Warning! ${title}</strong>`;
        } else {
            displayType = `<strong class="me-auto">${title}</strong>`;
        }

        //data delay is 10 sec
        let html = `
            <div class="toast fade hide" role="alert" aria-live="assertive" aria-atomic="true" data-delay="10000" id="toast-${numOfToasts}">
              <div class="toast-header">
                <i class="fa fa-bell mx-1 h-auto"></i>
                ${displayType}
                <!-- <small>Toast: ${numOfToasts}</small> -->
                <small></small>
                <button type="button" class="ms-2 mb-1 close" data-dismiss="toast" aria-label="Close">
                  <span aria-hidden="true">×</span>
                </button>
              </div>
              <div class="toast-body">
                <p>
                    ${content}
                </p>
              </div>
            </div>
        `;

        $('.toast-position').append(html);
        $(`#toast-${numOfToasts}`).toast('show');
        $(`#toast-${numOfToasts - 1}`).toast('hide');
    }
}
