% graph foveated plot
figure
x = 0:4; y = [3 2 1 1 1]; scatter(x,y, 140./y, 'filled');
t = text(x+dx, y, {'v_s = 0', 'v_s = 1', 'v_s = 2', 'v_s = 2', 'v_s = 2'});
set(t, 'FontSize', 15)
ylim([0 4])
xlabel('radial distance (x,y) from (h,c)')
ylabel('f(x,y)')
set(gca, 'FontSize', 15)
set(gca,'XTick', 0:4)
set(gca,'YTick',0:4)
grid on 
